/**
 * Created by famoser on 12/06/2016.
 */
function Initialize() {
    $('tr[data-href]').on("click", function () {
        document.location = $(this).data('href');
    });
}