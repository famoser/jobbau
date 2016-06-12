<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 18:10
 */

namespace Famoser\MassPass\Models\View;


use Famoser\MassPass\Models\Entities\Availability;
use Famoser\MassPass\Models\Entities\Person;

class PersonModel extends BaseModel
{
    private $person;
    /* @var ProfessionInfoModel[] $professionInfoModels */
    private $professionInfoModels;
    /* @var SkillInfoModel[] $skillInfoModels */
    private $skillInfoModels;
    /* @var AvailabilityModel[] $availabilityModels */
    private $availabilityModels;

    /**
     * PersonViewModel constructor.
     * @param Person $person
     * @param ProfessionInfoModel[] $professionViewModels
     * @param SkillInfoModel[] $skillViewModels
     * @param AvailabilityModel[] $availability
     */
    public function __construct(Person $person, array $professionViewModels, array $skillViewModels, array $availability)
    {
        $this->person = $person;
        $this->professionInfoModels = $professionViewModels;
        $this->skillInfoModels = $skillViewModels;
        $this->availabilityModels = $availability;
    }

    public function getPerson()
    {
        return $this->person;
    }

    public function getSortClasses()
    {
        $classes = array();
        foreach ($this->skillInfoModels as $skillViewModel) {
            $temp = $skillViewModel->getSkillSortClassArray();
            if ($temp != "")
                $classes = array_merge($classes, $temp);
        }

        foreach ($this->professionInfoModels as $professionViewModel) {
            $newClasses = $professionViewModel->getProfessionSortClassArray();
            if (is_array($newClasses))
                $classes = array_merge($classes, $newClasses);
        }

        return join(" ", $classes);
    }

    public function getName()
    {
        return $this->person->first_name . " " . $this->person->last_name;
    }

    public function getProfessions()
    {
        $professions = array();
        foreach ($this->professionInfoModels as $professionViewModel) {
            $temp = $professionViewModel->getProfessionText();
            if ($temp != "")
                $professions[] = $temp;
        }
        return join(", ", $professions);
    }

    public function getSkills()
    {
        $skills = array();
        foreach ($this->skillInfoModels as $skillViewModel) {
            $temp = $skillViewModel->getSkill();
            if ($temp != "")
                $skills[] = $temp;
        }
        return join(", ", $skills);
    }

    public function getAvailabilityModels()
    {
        if (!$this->person->looking_for_job)
            return "nicht verfügbar (nicht auf jobsuche)";

        $minDate = PHP_INT_MAX;
        $today = time();
        foreach ($this->availabilityModels as $item) {
            if ($item->start_date < $minDate && $item->end_date > $today) {
                $minDate = $item->start_date;
            }
        }
        if ($minDate < PHP_INT_MAX) {
            return "verfügbar ab " . date("d.m.Y", $minDate);
        }
        return "nicht verfügbar";
    }

    public function getAge()
    {
        //date in mm/dd/yyyy format; or it can be in other formats as well
        $birthDate = date("mm/dd/yyyy", $this->getPerson()->birthday_date);
        //explode the date to get month, day and year
        $birthDate = explode("/", $birthDate);
        $age = (date("md", date("U", mktime(0, 0, 0, $birthDate[0], $birthDate[1], $birthDate[2]))) > date("md")
            ? ((date("Y") - $birthDate[2]) - 1)
            : (date("Y") - $birthDate[2]));
        return $age;
    }

    /**
     * @return ProfessionInfoModel[]
     */
    public function getProfessionInfoModels()
    {
        return $this->professionInfoModels;
    }

    /**
     * @return SkillInfoModel[]
     */
    public function getSkillInfoModels()
    {
        return $this->skillInfoModels;
    }
}