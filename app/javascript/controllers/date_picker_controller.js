import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    var now = new Date();

    var day = ("0" + now.getDate()).slice(-2);
    var month = ("0" + (now.getMonth() + 1)).slice(-2);

    var today = now.getFullYear()+"-"+(month)+"-"+(day) ;
    $('#date-picker').val(today);
  }
}
