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
    private $professionViewModels;
    private $skillViewModels;
    private $availability;

    /**
     * PersonViewModel constructor.
     * @param Person $person
     * @param ProfessionModel[] $professionViewModels
     * @param SkillModel[] $skillViewModels
     * @param Availability[] $availability
     */
    public function __construct(Person $person, array $professionViewModels, array $skillViewModels, array $availability)
    {
        $this->person = $person;
        $this->professionViewModels = $professionViewModels;
        $this->skillViewModels = $skillViewModels;
        $this->availability = $availability;
    }

    public function getSortClasses()
    {
        $classes = array();
        foreach ($this->skillViewModels as $skillViewModel) {
            $temp = $skillViewModel->getSkillSortClass();
            if ($temp != "")
                $classes[] = $temp;
        }

        foreach ($this->professionViewModels as $professionViewModel) {
            $newClasses = $professionViewModel->getProfessionSortClass();
            if (is_array($newClasses))
                $classes = array_merge($classes, $newClasses);
        }

        return $classes;
    }

    public function getName()
    {
        return $this->person->first_name . " " . $this->person->last_name;
    }

    public function getProfessions()
    {
        $professions = array();
        foreach ($this->professionViewModels as $professionViewModel) {
            $temp = $professionViewModel->getProfession();
            if ($temp != "")
                $professions[] = $temp;
        }
        return join(", ", $professions);
    }

    public function getSkills()
    {
        $skills = array();
        foreach ($this->skillViewModels as $skillViewModel) {
            $temp = $skillViewModel->getSkill();
            if ($temp != "")
                $skills[] = $temp;
        }
        return join(", ", $skills);
    }

    public function getAvailability()
    {
        if (!$this->person->looking_for_job)
            return "nicht verfügbar (nicht auf jobsuche)";

        $minDate = PHP_INT_MAX;
        $today = time();
        foreach ($this->availability as $item) {
            if ($item->start_date < $minDate && $item->end_date > $today) {
                $minDate = $item->start_date;
            }
        }
        if ($minDate < PHP_INT_MAX) {
            return "verfügbar ab " . date("d-m-Y", $minDate);
        }
        return "nicht verfügbar";
    }
}