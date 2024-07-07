import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove(e) {
    document.getElementById('tag').disabled = true;
    document.getElementById('tag-destroy').value = 1;
    document.getElementById('destroy-btn').style.display = 'none';
    document.getElementById('restore-btn').style.display = 'block';
  }

  restore(e) {
    document.getElementById('tag').disabled = false;
    document.getElementById('tag-destroy').value = 0;
    document.getElementById('destroy-btn').style.display = 'block';
    document.getElementById('restore-btn').style.display = 'none';
  }
}
