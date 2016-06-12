<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 11/06/2016
 * Time: 18:46
 */

namespace Famoser\MassPass\Repositories;


use Famoser\MassPass\Helpers\DatabaseHelper;
use Famoser\MassPass\Models\Entities\Professions;
use Famoser\MassPass\Models\Entities\Skills;
use Famoser\MassPass\Models\Entities\Trainings;
use Famoser\MassPass\Models\View\ProfessionModel;
use Famoser\MassPass\Models\View\SkillModel;
use Famoser\MassPass\Models\View\TrainingModel;

class TrainingRepository extends GenericRepository
{
    public function getTrainings()
    {
        return $this->genericGetAllAsViewModels(new Trainings(), new TrainingModel(new Trainings()));
    }
}