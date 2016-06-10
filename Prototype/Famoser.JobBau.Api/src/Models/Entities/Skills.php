<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 23/05/2016
 * Time: 21:14
 */

namespace Famoser\MassPass\Models\Entities;


use Famoser\MassPass\Models\Entities\Base\BaseEntity;

class Skills extends BaseEntity
{
    public $name;
    public $type;
    public $additionalData;

    public function getTableName()
    {
        return "skills";
    }
}