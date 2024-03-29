<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 11/06/2016
 * Time: 18:46
 */

namespace Famoser\MassPass\Repositories;


use Famoser\MassPass\Helpers\DatabaseHelper;
use Famoser\MassPass\Models\Entities\Skills;
use Famoser\MassPass\Models\View\SkillModel;

class SkillRepository extends GenericRepository
{
    public function getSkills()
    {
        return $this->genericGetAllAsViewModels(new Skills(), new SkillModel(new Skills()));
    }
}