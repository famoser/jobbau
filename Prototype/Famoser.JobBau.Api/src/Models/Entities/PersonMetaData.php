<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 23/05/2016
 * Time: 21:17
 */

namespace Famoser\MassPass\Models\Entities;


use Famoser\MassPass\Models\Entities\Base\BaseEntity;

class PersonMetaData extends BaseEntity
{
    public $person_id;
    public $comment_private;
    public $status_private;

    public function getTableName()
    {
        return "person_meta_data";
    }
}