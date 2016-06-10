<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 29/05/2016
 * Time: 20:15
 */

namespace Famoser\MassPass\Models\Entities;


use Famoser\MassPass\Models\Entities\Base\BaseEntity;

class ProfessionInfo extends BaseEntity
{
    public $person_id;
    public $profession_id;
    public $other_beruf;
    public $training_id;
    public $other_training;
    public $experience;

    public function getTableName()
    {
        return "profession_info";
    }
}