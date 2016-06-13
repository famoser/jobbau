<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 18:41
 */

namespace Famoser\MassPass\Models\View;


use Famoser\MassPass\Models\Entities\Trainings;

class TrainingModel extends BaseModel
{
    private $training;

    public function __construct(Trainings $training)
    {
        $this->training = $training;
    }

    public function getSortClass()
    {
        return "training_" . $this->training->id;
    }

    public function getProfessionSortClass()
    {
        return "profession_" . $this->training->profession_id;
    }

    public function getName()
    {
        return $this->training->name;
    }

    /**
     * @return Trainings
     */
    public function getTraining()
    {
        return $this->training;
    }
}