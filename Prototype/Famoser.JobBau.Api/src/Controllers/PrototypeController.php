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
use Famoser\MassPass\Models\Entities\Professions;
use Famoser\MassPass\Models\Entities\SkillInfo;
use Famoser\MassPass\Models\Entities\Skills;
use Famoser\MassPass\Models\Entities\Trainings;
use Famoser\MassPass\Models\Response\SubmitResponse;
use Famoser\MassPass\Models\View\AvailabilityModel;
use Famoser\MassPass\Models\View\PersonModel;
use Famoser\MassPass\Models\View\ProfessionInfoModel;
use Famoser\MassPass\Models\View\ProfessionModel;
use Famoser\MassPass\Models\View\SkillInfoModel;
use Famoser\MassPass\Models\View\SkillModel;
use Famoser\MassPass\Models\View\TrainingModel;
use Famoser\MassPass\Types\ApiErrorTypes;
use Slim\Exception\NotFoundException;
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
            $file = new File('imageFile', $storage);
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
            $person->picture_src = $model->Person->guid . "." . $file->getExtension();
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

    public function entries(Request $request, Response $response, $args)
    {
        $helper = $this->getDatabaseHelper();

        $skills = $helper->getFromDatabase(new Skills(), null, null, "id");
        $skillsVm = array();
        foreach ($skills as $skill) {
            $skillsVm[] = new SkillModel($skill);
        }
        $args["skills"] = $skillsVm;

        $professions = $helper->getFromDatabase(new Professions(), null, null, "id");
        $prefessionsVm = array();
        foreach ($professions as $profession) {
            $prefessionsVm[] = new ProfessionModel($profession);
        }
        $args["professions"] = $prefessionsVm;

        $trainings = $helper->getFromDatabase(new Trainings(), null, null, "id");
        $trainingsVm = array();
        foreach ($trainings as $training) {
            $trainingsVm[] = new TrainingModel($training);
        }
        $args["trainings"] = $trainingsVm;

        $persons = $helper->getFromDatabase(new Person());
        $personViewModels = array();
        foreach ($persons as $person) {
            $availabilities = $helper->getFromDatabase(new Availability(), "person_id=:id", array("id" => $person->id));
            $availabilityVms = array();
            foreach ($availabilities as $availability) {
                $availabilityVms[] = new AvailabilityModel($availability);
            }

            $professionInfos = $helper->getFromDatabase(new ProfessionInfo(), "person_id=:id", array("id" => $person->id));
            $professionInfosVm = array();
            foreach ($professionInfos as $profs) {
                $professionInfosVm[] = new ProfessionInfoModel($profs, $professions, $trainings);
            }
            $skillInfos = $helper->getFromDatabase(new SkillInfo(), "person_id=:id", array("id" => $person->id));
            $skillInfosVm = array();
            foreach ($skillInfos as $skill) {
                $skillInfosVm[] = new SkillInfoModel($skill, $skills);
            }
            $personViewModels[] = new PersonModel($person, $professionInfosVm, $skillInfosVm, $availabilityVms);
        }
        $args["persons"] = $personViewModels;
        $args["entry_url"] = ($request->getAttribute("test_mode")) ? "entry-tests" : "entry";

        return $this->renderTemplate($response, "backend/list", $args);
    }

    public function createSamples(Request $request, Response $response, $args)
    {
        if (!$request->getAttribute("test_mode"))
            return $response->write("denied");

        $this->loadAndExecuteFolder("initializeData");
        $this->loadAndExecuteFolder("testData");
        return $response->write("true");
    }

    public function initializeDatabase(Request $request, Response $response, $args)
    {
        $this->loadAndExecuteFolder("initializeData");
        return $response->write("true");
    }

    private function loadAndExecuteFolder($relativeFolder)
    {
        $helper = $this->getDatabaseHelper();;
        $testDataFiles = glob($this->container["settings"]["asset_path"] . "/" . $relativeFolder . "/*"); // get all file names
        foreach ($testDataFiles as $file) { // iterate files
            if (is_file($file)) {
                $table = substr(basename($file), 0, strlen(".json") * -1);
                $json = file_get_contents($file);
                $list = json_decode($json, true);
                $helper->execute("DELETE FROM " . $table);
                foreach ($list as $item) {
                    $helper->insertRaw($table, $item);
                }
            }
        }
    }

    public function displayEntry(Request $request, Response $response, $args)
    {
        $helper = $this->getDatabaseHelper();

        $person = $helper->getSingleFromDatabaseById(new Person(), $args["id"]);
        if ($person == null)
            throw new NotFoundException($request, $response);

        $skills = $helper->getFromDatabase(new Skills(), null, null, "id");
        $skillsVm = array();
        foreach ($skills as $skill) {
            $skillsVm[] = new SkillModel($skill);
        }

        $professions = $helper->getFromDatabase(new Professions(), null, null, "id");
        $prefessionsVm = array();
        foreach ($professions as $profession) {
            $prefessionsVm[] = new ProfessionModel($profession);
        }

        $trainings = $helper->getFromDatabase(new Trainings(), null, null, "id");
        $trainingsVm = array();
        foreach ($trainings as $training) {
            $trainingsVm[] = new TrainingModel($training);
        }

        $availabilities = $helper->getFromDatabase(new Availability(), "person_id=:id", array("id" => $person->id));
        $availabilityVms = array();
        foreach ($availabilities as $availability) {
            $availabilityVms[] = new AvailabilityModel($availability);
        }

        $professionInfos = $helper->getFromDatabase(new ProfessionInfo(), "person_id=:id", array("id" => $person->id));
        $professionInfosVm = array();
        foreach ($professionInfos as $profs) {
            $professionInfosVm[] = new ProfessionInfoModel($profs, $professions, $trainings);
        }
        $skillInfos = $helper->getFromDatabase(new SkillInfo(), "person_id=:id", array("id" => $person->id));
        $skillInfosVm = array();
        foreach ($skillInfos as $skill) {
            $skillInfosVm[] = new SkillInfoModel($skill, $skills);
        }
        $personViewModel = new PersonModel($person, $professionInfosVm, $skillInfosVm, $availabilityVms);

        $args["person"] = $personViewModel;

        return $this->renderTemplate($response, "backend/entry", $args);
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