//
//  BasePresenter.swift
//  Base Movistar
//
//  Created by Adolfo Encinas Martín on 27/09/2018.
//  Copyright © 2018 Eleven Paths. All rights reserved.
//

/// Base module interface where we will know the state of the view so we will do the stuff needed.
protocol BasePresenter: class {
	
	/// Method to report UI current status for view login provider (commonly the presenter) to take
    /// some actions.
	///
	/// - Parameter forState: current UI status (match with iOS view life cycle status for view
    ///                       controllers).
	func prepareView(forState state: ViewState)
}

/// Enum to know the state of the view (view controller life cycle)
///
/// - loadView: view is created programmatically
/// - didLoad: view did load life cycle event
/// - willAppear: view will appear life cycle event
/// - didAppear: did appear life cycle event
/// - willDisappear: will disappear life cycle event
/// - didDisappear: did disappear life cycle event
enum ViewState: Int {
	
	case loadView, didLoad, willAppear, didAppear, willDisappear, didDisappear
	
	init() {
		
		self = .didLoad
	}
}
