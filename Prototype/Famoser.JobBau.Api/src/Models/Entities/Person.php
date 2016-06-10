<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 23/05/2016
 * Time: 21:16
 */

namespace Famoser\MassPass\Models\Entities;


use Famoser\MassPass\Models\Entities\Base\BaseEntity;

class Person extends BaseEntity
{
    public $guid;
    public $first_name;
    public $last_name;
    public $street_and_nr;
    public $address_line_2;
    public $plz;
    public $place;
    public $land;
    public $email;
    public $mobile;
    public $birthday_date;
    public $picture_src;
    public $looking_for_job;
    public $comment;


    public function getTableName()
    {
        return "persons";
    }
}