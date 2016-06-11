<?php
/**
 * Created by PhpStorm.
 * User: famoser
 * Date: 11/06/2016
 * Time: 18:54
 */

namespace Famoser\MassPass\Repositories;


use Famoser\MassPass\Models\Entities\Base\BaseEntity;
use Famoser\MassPass\Models\View\BaseViewModel;

class GenericRepository extends BaseRepository
{
    protected function genericGetAllAsViewModels(BaseEntity $entity, BaseViewModel $viewModel)
    {
        $entityClass = get_class($entity);
        $viewModelClass = get_class($viewModel);
        $entities = $this->databaseHelper->getFromDatabase(new $entityClass());
        $entityViewModel = array();
        foreach ($entities as $entity) {
            $entityViewModel[] = new $viewModelClass($entity);
        }

        return $entityViewModel;
    }
}