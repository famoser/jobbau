<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 16:46
 */

namespace Famoser\MassPass\Controllers;


use Famoser\MassPass\Helpers\FormatHelper;
use Famoser\MassPass\Helpers\RequestHelper;
use Famoser\MassPass\Helpers\ResponseHelper;
use Famoser\MassPass\Models\Entities\Availability;
use Famoser\MassPass\Models\Entities\Person;
use Famoser\MassPass\Models\Entities\ProfessionInfo;
use Famoser\MassPass\Models\Entities\SkillInfo;
use Famoser\MassPass\Models\Response\SubmitResponse;
use Famoser\MassPass\Types\ApiErrorTypes;
use Slim\Http\Request;
use Slim\Http\Response;
use Upload\File;
use Upload\Storage\FileSystem;

class PrototypeController extends BaseController
{
    public function submit(Request $request, Response $response, $args)
    {
        $model = RequestHelper::parseSubmitRequest($request);
        if ($this->isAuthorized($model)) {
            if (!$this->isWellDefined($model, array("Person"), array("ProfessionInfos", "SkillInfos", "Availabilities")))
                return $this->returnApiError(ApiErrorTypes::NotWellDefined, $response);

            $resp = new SubmitResponse();
            $helper = $this->getDatabaseHelper();

            //save file
            $storage = new FileSystem($this->getUserDirForContent($model->Person->guid));
            $file = new File('updateFile', $storage);
            $file->setName($model->Person->guid);
            $file->upload();

            //add database
            $person = new Person();
            $person->guid = $model->Person->guid;
            $person->first_name = $model->Person->first_name;
            $person->last_name = $model->Person->last_name;
            $person->street_and_nr = $model->Person->street_and_nr;
            $person->address_line_2 = $model->Person->address_line_2;
            $person->place = $model->Person->place;
            $person->plz = $model->Person->plz;
            $person->land = $model->Person->land;
            $person->birthday_date = FormatHelper::fromSwiftDate($model->Person->birthday_date);
            $person->mobile = $model->Person->mobile;
            $person->email = $model->Person->email;
            $person->looking_for_job = true;

            if (!$helper->saveToDatabase($person)) {
                return $this->returnApiError(ApiErrorTypes::DatabaseFailure, $response);
            }

            foreach ($model->Availabilities as $availability) {
                $ava = new Availability();
                $ava->person_id = $person->id;

                $ava->start_date = FormatHelper::fromSwiftDate($availability->start_date);
                $ava->end_date = $availability->end_date != "" ? FormatHelper::fromSwiftDate($availability->end_date) : null;

                if (!$helper->saveToDatabase($ava)) {
                    return $this->returnApiError(ApiErrorTypes::DatabaseFailure, $response);
                }
            }

            foreach ($model->ProfessionInfos as $professionInfo) {
                $profInfo = new ProfessionInfo();
                $profInfo->person_id = $person->id;

                $profInfo->experience_type = $professionInfo->experience_type;
                $profInfo->profession_id = $professionInfo->experience_type;
                $profInfo->other_profession = $professionInfo->experience_type;
                $profInfo->training_id = $professionInfo->experience_type;
                $profInfo->other_training = $professionInfo->experience_type;

                if (!$helper->saveToDatabase($profInfo)) {
                    return $this->returnApiError(ApiErrorTypes::DatabaseFailure, $response);
                }
            }

            foreach ($model->SkillInfos as $skillInfo) {

                $nfo = new SkillInfo();
                $nfo->person_id = $person->id;

                $nfo->skill_id = $skillInfo->skill_id;
                $nfo->value = $skillInfo->value;

                if (!$helper->saveToDatabase($nfo)) {
                    return $this->returnApiError(ApiErrorTypes::DatabaseFailure, $response);
                }
            }

            return ResponseHelper::getJsonResponse($response, $resp);
        } else {
            return $this->returnApiError(ApiErrorTypes::NotAuthorized, $response);
        }
    }

    private function getUserDirForContent($userGuid)
    {
        $path = $this->container->get("settings")["file_path"] . "/" . $userGuid;
        if (!is_dir($path)) {
            mkdir($path);
        }
        return $path;
    }
}