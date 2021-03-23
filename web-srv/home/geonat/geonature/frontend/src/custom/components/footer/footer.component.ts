import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'pnx-footer',
  styleUrls: ['footer.component.scss'],
  templateUrl: 'footer.component.html'
})
export class FooterComponent implements OnInit {
	public startCopyrightYear = 2019;
	public currentCopyrightYear;

	constructor() {}

  ngOnInit() {
	this.currentCopyrightYear = this.startCopyrightYear;
	let currentYear = (new Date()).getFullYear();
	if (currentYear > this.startCopyrightYear) {
		this.currentCopyrightYear = `${this.startCopyrightYear}-${currentYear}`;
	}
  }
}
