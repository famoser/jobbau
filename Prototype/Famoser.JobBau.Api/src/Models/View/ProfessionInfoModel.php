<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 18:12
 */

namespace Famoser\MassPass\Models\View;


use Famoser\MassPass\Models\Entities\ProfessionInfo;
use Famoser\MassPass\Models\Entities\Professions;
use Famoser\MassPass\Models\Entities\Trainings;

class ProfessionInfoModel extends BaseModel
{
    private $info;
    private $professions;
    private $trainings;

    /**
     * ProfessionViewModel constructor.
     * @param ProfessionInfo $info
     * @param Professions[] $professions
     * @param Trainings[] $trainings
     */
    public function __construct(ProfessionInfo $info, array $professions, array $trainings)
    {
        $this->info = $info;
        $this->professions = $professions;
        $this->trainings = $trainings;
    }

    private function getProfessionName()
    {
        if ($this->info->profession_id == 0 || !isset($this->professions[$this->info->profession_id])) {
            return $this->info->other_profession;
        }

        return $this->professions[$this->info->profession_id]->name;
    }

    private function getTrainingName()
    {
        if ($this->info->training_id == 0 || !isset($this->trainings[$this->info->training_id])) {
            return $this->info->other_training;
        }

        return $this->trainings[$this->info->training_id]->name;
    }

    public function getProfession()
    {
        $profession = $this->getProfessionName();
        $training = $this->getTrainingName();
        if ($profession != "") {
            if ($training != "") {
                return $profession . " (" . $training . ")";
            }
            return $profession;
        }
        return null;
    }

    public function getProfessionSortClass()
    {
        $profession = $this->getProfessionName();
        $training = $this->getTrainingName();
        $arr = array();
        if ($profession != "") {
            $arr[] = "profession_" . $this->info->profession_id;
        }
        if ($training != "") {
            $arr[] = "training_" . $this->info->training_id;
        }
        return $arr;
    }
}