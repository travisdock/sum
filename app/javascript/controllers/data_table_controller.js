import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    jQuery.fn.dataTable.Api.register( 'sum()', function ( ) {
        return this.flatten().reduce( function ( a, b ) {
            if ( typeof a === 'string' ) {
                a = a.replace(/[^\d.-]/g, '') * 1;
            }
            if ( typeof b === 'string' ) {
                b = b.replace(/[^\d.-]/g, '') * 1;
            }

            return a + b;
        }, 0 );
    } );
    const num2curr = num => '$'+num.toFixed(2).replace(/\d(?=(\d{3})+\.)/g, '$&,');

    var table = $('.table').DataTable({
       paging: false,
       order: [[ 0, "desc" ]],
       info: false,
       //dom: '<"#toolbar.float-start">frtip',
       dom: "<'row'<'#toolbar.col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>>" +
               "<'row'<'col-sm-12'tr>>" +
                       "<'row'<'col-sm-12 col-md-5'i><'col-sm-12 col-md-7'p>>",
       drawCallback: function() {
         const sum = this.api().column(1,{search:'applied'}).data().sum();
         $('#toolbar').text(`Sum: ${num2curr(sum)}`);
       }
     });
    $(".clickable-row").click(function() {
        window.location = $(this).data("href");
    });
  }
}
