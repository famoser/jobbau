<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 23/05/2016
 * Time: 21:14
 */

namespace Famoser\MassPass\Models\Entities;


use Famoser\MassPass\Models\Entities\Base\BaseEntity;

class Trainings extends BaseEntity
{
    public $profession_id;
    public $name;

    public function getTableName()
    {
        return "trainings";
    }
}