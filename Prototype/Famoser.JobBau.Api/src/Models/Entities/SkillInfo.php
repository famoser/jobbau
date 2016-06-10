<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 23/05/2016
 * Time: 21:13
 */

namespace Famoser\MassPass\Models\Entities;


use Famoser\MassPass\Models\Entities\Base\BaseEntity;

class SkillInfo extends BaseEntity
{
    public $person_id;
    public $skill_id;
    public $value;

    public function getTableName()
    {
        return "skill_info";
    }
}