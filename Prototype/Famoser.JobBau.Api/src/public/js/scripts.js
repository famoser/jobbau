/**
 * Created by famoser on 12/06/2016.
 */
function Initialize() {
    $('tr[data-href], div[data-href]').on("click", function () {
        document.location = $(this).data('href');
    });


    var $grid = $('.filter-target').isotope({
        itemSelector: '.filter-item',
        layoutMode: 'masonry'
    });


    var $filters = $('.filters');
    // bind filter button click
    $filters.on('click', 'li button', function () {
        console.log("logged");
        var filterValue = $(this).attr('data-filter');
        $grid.isotope({filter: filterValue});
    });

    // change is-checked class on buttons
    $filters.each(function (i, buttonGroup) {
        var $buttonGroup = $(buttonGroup);
        $buttonGroup.on('click', 'button', function () {
            $buttonGroup.find('.selected').removeClass('selected');
            $(this).addClass('selected');
        });
    });

}