//
//  CoachMarksController.swift
//  Instructions
//
//  Created by Frédéric Maquin on 10/10/15.
//  Copyright © 2015 Ephread. All rights reserved.
//

import XCTest
@testable import Instructions

class CoachMarksControllerTests: XCTestCase, CoachMarksControllerDelegate {

    let coachMarksController = CoachMarksController()
    let parentController = UIViewController()
    let mockedDataSource = CoachMarkControllerMockedDataSource()
    let mockedWindow = UIWindow()

    var delegateEndExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()
        
        self.coachMarksController.datasource = self.mockedDataSource
        self.coachMarksController.delegate = self

        self.mockedWindow.addSubview(self.parentController.view)
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testThatCoachMarkControllerAttachItselfToParent() {
        self.coachMarksController.startOn(self.parentController)

        self.parentController.childViewControllers
        XCTAssertTrue(self.parentController.childViewControllers.contains(self.coachMarksController))
    }

    func testThatDidFinishShowingIsCalled() {
        self.delegateEndExpectation = self.expectation(description: "DidFinishShowing")

        self.coachMarksController.startOn(self.parentController)
        self.coachMarksController.finish()

        self.waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testThatCoachMarkControllerDetachItselfFromParent() {
        self.delegateEndExpectation = self.expectation(description: "Detachment")

        self.coachMarksController.startOn(self.parentController)
        self.coachMarksController.finish()

        self.waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func didFinishShowingFromCoachMarksController(_ coachMarksController: CoachMarksController) {
        guard let delegateEndExpectation = self.delegateEndExpectation else {
            XCTFail()
            return
        }

        if (delegateEndExpectation.description == "Detachment") {
            self.parentController.childViewControllers
            XCTAssertFalse(self.parentController.childViewControllers.contains(self.coachMarksController))

            delegateEndExpectation.fulfill()
        } else if (delegateEndExpectation.description == "DidFinishShowing") {
            XCTAssertTrue(true)
            delegateEndExpectation.fulfill()
        } else {
            XCTFail()
        }
    }
}

internal class CoachMarkControllerMockedDataSource : CoachMarksControllerDataSource {

    func numberOfCoachMarksForCoachMarksController(_ coachMarksController: CoachMarksController) -> Int {
        return 1
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarksForIndex index: Int) -> CoachMark {
        return CoachMark()
    }

    func coachMarksController(_ coachMarksController: CoachMarksController, coachMarkViewsForIndex index: Int, coachMark: CoachMark) -> (bodyView: CoachMarkBodyView, arrowView: CoachMarkArrowView?) {
        return (CoachMarkBodyDefaultView(), nil)
    }
}
