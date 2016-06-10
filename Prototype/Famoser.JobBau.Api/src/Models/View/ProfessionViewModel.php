<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 18:41
 */

namespace Famoser\MassPass\Models\View;


use Famoser\MassPass\Models\Entities\Professions;
use Famoser\MassPass\Models\Entities\Trainings;

class ProfessionViewModel
{
    private $profession;

    public function __construct(Professions $profession)
    {
        $this->profession = $profession;
    }

    public function getSortClass()
    {
        return $this->profession->id;
    }

    public function getName()
    {
        return $this->profession->name;
    }
}