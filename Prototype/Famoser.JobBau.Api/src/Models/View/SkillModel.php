<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 18:41
 */

namespace Famoser\MassPass\Models\View;


use Famoser\MassPass\Models\Entities\Skills;

class SkillModel extends BaseModel
{
    private $skill;

    public function __construct(Skills $skill)
    {
        $this->skill = $skill;
    }

    public function getSortClass()
    {
        return "skill_".$this->skill->id;
    }

    public function getName()
    {
        return $this->skill->name;
    }

    /**
     * @return Skills
     */
    public function getSkill()
    {
        return $this->skill;
    }
}