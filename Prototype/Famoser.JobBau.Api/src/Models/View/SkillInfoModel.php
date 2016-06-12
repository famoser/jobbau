<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 18:14
 */

namespace Famoser\MassPass\Models\View;


use Famoser\MassPass\Models\Entities\SkillInfo;
use Famoser\MassPass\Models\Entities\Skills;
use Famoser\MassPass\Types\SkillTypes;

class SkillInfoModel extends BaseModel
{
    private $info;
    private $skills;

    /**
     * SkillsViewModel constructor.
     * @param SkillInfo $info
     * @param Skills[] $skills
     */
    public function __construct(SkillInfo $info, array $skills)
    {
        $this->info = $info;
        $this->skills = $skills;
    }

    public function getSkill()
    {
        if (isset($this->skills[$this->info->skill_id])) {
            $skill = $this->skills[$this->info->skill_id];
            if ($skill->type == SkillTypes::BOOLEAN) {
                if ($this->info->value)
                    return $this->skills[$this->info->skill_id]->name;
            }
        }
        return null;
    }

    public function getSkillSortClassArray()
    {
        $arr = array();
        if (isset($this->skills[$this->info->skill_id])) {
            $skill = $this->skills[$this->info->skill_id];
            if ($skill->type == SkillTypes::BOOLEAN) {
                if ($this->info->value)
                    $arr[] = "skill_" . $this->info->skill_id;
            }
        }
        return $arr;
    }
}