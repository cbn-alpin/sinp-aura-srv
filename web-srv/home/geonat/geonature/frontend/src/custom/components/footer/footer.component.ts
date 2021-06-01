import { Component, OnInit, Inject } from '@angular/core';

import { NgbModal } from '@ng-bootstrap/ng-bootstrap';

@Component({
  selector: 'pnx-footer',
  styleUrls: ['footer.component.scss'],
  templateUrl: 'footer.component.html'
})
export class FooterComponent implements OnInit {
	public startCopyrightYear = 2019;
	public currentCopyrightYear;

	constructor(
    private modalService: NgbModal
  ) {}

  ngOnInit() {
    this.currentCopyrightYear = this.startCopyrightYear;
    let currentYear = (new Date()).getFullYear();
    if (currentYear > this.startCopyrightYear) {
      this.currentCopyrightYear = `${this.startCopyrightYear}-${currentYear}`;
    }
  }

  open(content) {
    this.modalService.open(content, {size: 'lg', ariaLabelledBy: 'modal-basic-title'});
  }
}
