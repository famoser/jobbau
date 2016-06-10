<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 07/06/2016
 * Time: 17:54
 */

namespace Famoser\MassPass\Controllers;


use Famoser\MassPass\Models\ApiConfiguration;
use PHPQRCode\Constants;
use PHPQRCode\QRcode;
use Slim\Http\Request;
use Slim\Http\Response;

class PublicController extends BaseController
{
    public function index(Request $request, Response $response, $args)
    {
        return $this->renderTemplate($response, "index", $args);
    }
}