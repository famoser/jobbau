<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 16:37
 */

namespace Famoser\MassPass\Models\Request;


use Famoser\MassPass\Models\Request\Base\ApiRequest;

class SubmitRequest extends ApiRequest
{
    /**
     * @var Entities\PersonEntity $Person
     */
    public $Person;

    /**
     * @var Entities\ProfessionInfoEntity[] $ProfessionInfos
     */
    public $ProfessionInfos;

    /**
     * @var Entities\SkillInfoEntity[] $SkillInfos
     */
    public $SkillInfos;

    /**
     * @var Entities\AvailabilityEntity[] $Availabilities
     */
    public $Availabilities;

}