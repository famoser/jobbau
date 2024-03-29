<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 22/05/2016
 * Time: 22:40
 */

use Famoser\MassPass\Helpers\DatabaseHelper;
use Famoser\MassPass\Helpers\RequestHelper;
use Famoser\MassPass\Helpers\ResponseHelper;
use Famoser\MassPass\Middleware\ApiVersionMiddleware;
use Famoser\MassPass\Middleware\AuthorizationMiddleware;
use Famoser\MassPass\Middleware\JsonMiddleware;
use Famoser\MassPass\Middleware\LoggingMiddleware;
use Famoser\MassPass\Middleware\TestsMiddleware;
use Famoser\MassPass\Models\Request\Base\ApiRequest;
use Famoser\MassPass\Models\Request\RefreshRequest;
use Famoser\MassPass\Models\Response\Base\ApiResponse;
use Famoser\MassPass\Types\ApiErrorTypes;
use \Psr\Http\Message\ServerRequestInterface as Request;
use \Psr\Http\Message\ResponseInterface as Response;
use Slim\App;
use Slim\Container;

require '../../vendor/autoload.php';

$configuration = [
    'settings' => [
        'displayErrorDetails' => false,
        'debug_mode' => true,
        'db' => [
            'path' => "sqlite.db",
            'test_path' => "sqlite_tests.db"
        ],
        'data_path' => realpath("../../app"),
        'asset_path' => realpath("../Assets"),
        'log_path' => realpath("../../app/logs"),
        'file_path' => realpath("../public/images/portraits"),
        'template_path' => realpath("../../app/templates"),
        'cache_path' => realpath("../../app/cache"),
        'public_path' => realpath("../public")
    ],
    'api_settings' => [
        'api_version' => 1,
        'test_mode' => false
    ]
];

$c = new Container($configuration);
$c['notFoundHandler'] = function (Container $c) {
    return function (Request $req, Response $resp) use ($c) {
        $res = new ApiResponse(false, ApiErrorTypes::RequestUriInvalid);
        if ($c->get("settings")["debug_mode"]) {
            $res->DebugMessage = "requested: " . $req->getRequestTarget();
        }

        return $resp->withStatus(404, "endpoint not found")->withJson($res);
    };
};
$c['notAllowedHandler'] = function (Container $c) {
    return function (Request $req, Response $resp) use ($c) {
        $res = new ApiResponse(false, ApiErrorTypes::RequestUriInvalid);
        if ($c->get("settings")["debug_mode"])
            $res->DebugMessage = "requested: " . $req->getRequestTarget();

        return $resp->withStatus(405, "wrong method")->withJson($res);
    };
};
$c['errorHandler'] = function (Container $c) {
    /**
     * @param $request
     * @param $response
     * @param $exception
     * @return mixed
     */
    return function (Request $request, Response $response, Exception $exception) use ($c) {
        $res = new ApiResponse(false, ApiErrorTypes::ServerFailure);
        if ($c->get("settings")["debug_mode"])
            $res->DebugMessage = "Exception: " . $exception->getMessage() . " \nStack: " . $exception->getTraceAsString();
        return $response->withStatus(500, $exception->getMessage())->withJson($res);
    };
};
// Register component on container
$c['view'] = function (Container $c) {
    $view = new \Slim\Views\Twig($c->get("settings")["template_path"], [
        'cache' => $c->get("settings")["cache_path"],
        'debug' => $c->get("settings")["debug_mode"]
    ]);
    $view->addExtension(new \Slim\Views\TwigExtension(
        $c['router'],
        $c['request']->getUri()
    ));

    return $view;
};

$controllerNamespace = 'Famoser\MassPass\Controllers\\';
$test_mode = false;

$app = new App($c);
$app->add(new JsonMiddleware());
$app->add(new AuthorizationMiddleware());
$app->add(new ApiVersionMiddleware($c));
$app->add(new TestsMiddleware($c));
$app->add(new LoggingMiddleware($c));

function makeRoutes(App &$app, $controllerNamespace, $appendix = "")
{
    $app->post('/submit', $controllerNamespace . 'PrototypeController:submit')->setName("submit".$appendix);
    $app->get('/entries', $controllerNamespace . 'PrototypeController:entries')->setName("entries".$appendix);
    $app->get('/entries/{id:[0-9]+}', $controllerNamespace . 'PrototypeController:displayEntry')->setName("entry".$appendix);
    $app->get('/entries/createSamples', $controllerNamespace . 'PrototypeController:createSamples')->setName("samples".$appendix);
    $app->get('/entries/init', $controllerNamespace . 'PrototypeController:initializeDatabase')->setName("init".$appendix);
}

$app->group("/tests/1.0", function ()  use ($controllerNamespace) {
    makeRoutes($this, $controllerNamespace, "-tests");
});
$app->group("/1.0", function ()  use ($controllerNamespace) {
    makeRoutes($this, $controllerNamespace);
});

$app->get("/1.0/", $controllerNamespace . 'PublicController:index');

$app->run();