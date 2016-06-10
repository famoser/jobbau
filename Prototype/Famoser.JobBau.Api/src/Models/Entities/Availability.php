<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 23/05/2016
 * Time: 21:13
 */

namespace Famoser\MassPass\Models\Entities;


use Famoser\MassPass\Models\Entities\Base\BaseEntity;

class Availability extends BaseEntity
{
    public $person_id;
    public $start_date;
    public $end_date;

    public function getTableName()
    {
        return "availability";
    }
}