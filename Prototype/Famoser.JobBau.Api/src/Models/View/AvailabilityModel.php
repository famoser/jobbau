<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 12/06/2016
 * Time: 11:56
 */

namespace Famoser\MassPass\Models\View;


use Famoser\MassPass\Models\Entities\Availability;

class AvailabilityModel
{
    private $availability;

    public function __construct(Availability $availability)
    {
        $this->availability = $availability;
    }

    public function getStartDate()
    {
        if ($this->availability->start_date == 0)
            return "-";
        return date("d.m.Y", $this->availability->start_date);
    }

    public function getEndDate()
    {
        if ($this->availability->end_date == 0)
            return "-";
        return date("d.m.Y", $this->availability->end_date);
    }

    public function getIsAvailable()
    {
        $time = strtotime("today + 4 week");
        if ($this->availability->start_date < $time && $this->availability->end_date > $time)
            return true;
        return false;
    }

    /**
     * @return Availability
     */
    public function getAvailability()
    {
        return $this->availability;
    }
}