<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 11/06/2016
 * Time: 18:47
 */

namespace Famoser\MassPass\Repositories;


use Famoser\MassPass\Helpers\DatabaseHelper;
use Famoser\MassPass\Models\Entities\Base\BaseEntity;
use Famoser\MassPass\Models\View\BaseViewModel;

class BaseRepository
{
    protected $databaseHelper;

    public function __construct(DatabaseHelper $helper)
    {
        $this->databaseHelper = $helper;
    }
    
    protected function getAllFromDatabaseToViewModels(BaseEntity $entity, BaseViewModel $viewModel)
    {
        
    }
}