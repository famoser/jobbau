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
use Famoser\MassPass\Models\View\ProfessionModel;
use Famoser\MassPass\Models\View\SkillModel;

class ProfessionRepository extends GenericRepository
{
    public function getProfessions()
    {
        return $this->genericGetAllAsViewModels(new Professions(), new ProfessionModel(new Professions()));
    }
}