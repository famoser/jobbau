<?php
/**
 * Created by PhpStorm.
 * User: Florian Moser
 * Date: 10.06.2016
 * Time: 16:40
 */

namespace Famoser\MassPass\Types;


class ExperienceTypes
{
    const None = 0;
    const OneToThreeYears = 1;
    const ThreeToFiveYears = 2;
    const FiveToTenYears = 3;
    const MoreThanTenYears = 4;

    public static function toString($experienceType)
    {
        switch ($experienceType) {
            case ExperienceTypes::None:
                return "keine";
            case ExperienceTypes::OneToThreeYears:
                return "1 - 3 Jahre";
            case ExperienceTypes::ThreeToFiveYears:
                return "3 - 5 Jahre";
            case ExperienceTypes::FiveToTenYears:
                return "5 - 10 Jahre";
            case ExperienceTypes::MoreThanTenYears:
                return "> 10 Jahre";
        }
        return "unbekannt";
    }
}