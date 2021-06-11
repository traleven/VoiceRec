//
//  SelfSizedTableView.swift
//  AdjustableTableView
//
//  Created by Dushyant Bansal on 25/02/18.
//  Copyright © 2018 db42.in. All rights reserved.
//
//  Based on: https://medium.com/infancyit/a-simple-solution-for-self-sizing-tableview-with-auto-resizing-cell-a3f82c4a1b34
import UIKit

@IBDesignable
class SelfSizedTableView: UITableView {
	var maxHeight: CGFloat = 10000

	override func awakeFromNib() {
		self.reloadData()
	}

  override func reloadData() {
	super.reloadData()
	self.invalidateIntrinsicContentSize()
	self.layoutIfNeeded()
  }

  override var intrinsicContentSize: CGSize {
	setNeedsLayout()
	layoutIfNeeded()
	let height = min(contentSize.height, maxHeight)
	return CGSize(width: contentSize.width, height: height)
  }
}
