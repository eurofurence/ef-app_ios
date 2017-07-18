//
//  TimeOffsetRow.swift
//  Eurofurence
//
//  Copyright © 2017 Eurofurence. All rights reserved.
//

import Foundation
import Eureka

open class TimeIntervalCell: Cell<TimeInterval>, CellType, UIPickerViewDelegate, UIPickerViewDataSource {

	public var pickerView: UIPickerView

	public required init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		pickerView = UIPickerView()
		super.init(style: style, reuseIdentifier: reuseIdentifier)
	}

	required public init?(coder aDecoder: NSCoder) {
		pickerView = UIPickerView()
		super.init(coder: aDecoder)
	}

	open override func setup() {
		super.setup()
		accessoryType = .none
		editingAccessoryType =  .none
		pickerView.dataSource = self
		pickerView.delegate = self
	}

	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		switch(component) {
		case 0:
			return 365
		case 1:
			return 24
		case 2:
			return 60
		default:
			return 0
		}
	}

	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		switch(component) {
		case 0:
			return "\(row) day\(row == 1 ? "" : "s")"
		case 1:
			return "\(row) hour\(row == 1 ? "" : "s")"
		case 2:
			return "\(row) minute\(row == 1 ? "" : "s")"
		default:
			return ""
		}
	}

	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 3
	}

	public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		self.row.value = getTimeInterval(from: pickerView)
		detailTextLabel?.text = self.row.displayValueFor?(self.row.value)
	}

	public func setTimeInterval(_ timeInterval: TimeInterval, to targetPickerView: UIPickerView) {
		guard targetPickerView.numberOfComponents == 3 && timeInterval > 0 else { return }

		targetPickerView.selectRow(Int(timeInterval.days), inComponent: 0, animated: false)
		targetPickerView.selectRow(timeInterval.hoursPart, inComponent: 1, animated: false)
		targetPickerView.selectRow(timeInterval.minutesPart, inComponent: 2, animated: false)
	}

	public func getTimeInterval(from targetPickerView: UIPickerView) -> TimeInterval {
		guard targetPickerView.numberOfComponents == 3 else { return 0.0 }

		var timeInterval = TimeInterval(targetPickerView.selectedRow(inComponent: 0)) * 24
		timeInterval = (timeInterval + TimeInterval(targetPickerView.selectedRow(inComponent: 1))) * 60
		timeInterval = (timeInterval + TimeInterval(targetPickerView.selectedRow(inComponent: 2))) * 60
		return timeInterval
	}

	open override func update() {
		super.update()
		selectionStyle = row.isDisabled ? .none : .default
		setTimeInterval(row.value ?? TimeInterval(), to: pickerView)
		if row.isHighlighted {
			textLabel?.textColor = tintColor
		}
	}

	open override func didSelect() {
		super.didSelect()
		row.deselect()
	}

	override open var inputView: UIView? {
		if let v = row.value {
			setTimeInterval(v, to: pickerView)
		}
		return pickerView
	}

	open override func cellCanBecomeFirstResponder() -> Bool {
		return canBecomeFirstResponder
	}

	override open var canBecomeFirstResponder: Bool {
		return !row.isDisabled
	}
}

public final class TimeIntervalRow: Row<TimeIntervalCell>, NoValueDisplayTextConformance, RowType {

	open var noValueDisplayText: String?

	required public init(tag: String?) {
		super.init(tag: tag)
		displayValueFor = { value in
			guard let val = value, val.minutes >= 1.0 else { return self.noValueDisplayText }
			return val.dhmString
		}
	}
}
