import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  remove(e) {
    document.getElementById('tag').disabled = true;
    document.getElementById('tag-destroy').value = 1;
    document.getElementById('destroy-btn').classList.add('invisible');
    document.getElementById('restore-btn').classList.remove('invisible');
  }

  restore(e) {
    document.getElementById('tag').disabled = false;
    document.getElementById('tag-destroy').value = 0;
    document.getElementById('destroy-btn').classList.remove('invisible');
    document.getElementById('restore-btn').classList.add('invisible');
  }
}
