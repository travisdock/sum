import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    $('.table').DataTable({
       paging: false,
       info: false
     });
    $(".clickable-row").click(function() {
        window.location = $(this).data("href");
    });
  }
}
