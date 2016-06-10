<?php

namespace Famoser\MassPass\Helpers;

use Famoser\MassPass\Models\Request\Authorization\AuthorizationRequest;
use Famoser\MassPass\Models\Request\Authorization\AuthorizationStatusRequest;
use Famoser\MassPass\Models\Request\Authorization\AuthorizedDevicesRequest;
use Famoser\MassPass\Models\Request\Authorization\CreateAuthorizationRequest;
use Famoser\MassPass\Models\Request\Authorization\UnAuthorizationRequest;
use Famoser\MassPass\Models\Request\CollectionEntriesRequest;
use Famoser\MassPass\Models\Request\ContentEntityHistoryRequest;
use Famoser\MassPass\Models\Request\ContentEntityRequest;
use Famoser\MassPass\Models\Request\RefreshRequest;
use Famoser\MassPass\Models\Request\SubmitRequest;
use Famoser\MassPass\Models\Request\UpdateRequest;
use Famoser\MassPass\Models\Response\Authorization\AuthorizedDevicesResponse;
use JsonMapper;
use \Psr\Http\Message\ServerRequestInterface as Request;

/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 22/05/2016
 * Time: 23:35
 */
class RequestHelper
{
    /**
     * @param Request $request
     * @return SubmitRequest
     * @throws \JsonMapper_Exception
     */
    public static function parseSubmitRequest(Request $request)
    {
        return RequestHelper::executeJsonMapper($request, new SubmitRequest());
    }

    private static function executeJsonMapper(Request $request, $model)
    {
        if (isset($_POST["json"]))
            $jsonObj = json_decode($_POST["json"]);
        else
            $jsonObj = json_decode($request->getBody()->getContents());

        $mapper = new JsonMapper();
        $mapper->bExceptionOnUndefinedProperty = true;
        $resObj = $mapper->map($jsonObj, $model);
        LogHelper::log(json_encode($resObj, JSON_PRETTY_PRINT), "RequestHelper.txt");
        return $resObj;
    }
}