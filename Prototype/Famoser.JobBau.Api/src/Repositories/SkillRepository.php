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
use Famoser\MassPass\Models\View\SkillViewModel;

class SkillRepository extends BaseRepository
{
    public function getSkills()
    {
        //return $this->getAllFromDatabaseToViewModels(new Skills(), new SkillViewModel());
        $skills = $this->databaseHelper->getFromDatabase(new Skills());
        $skillsVm = array();
        foreach ($skills as $skill) {
            $skillsVm[] = new SkillViewModel($skill);
        }
        
        return $skillsVm;
    }
}