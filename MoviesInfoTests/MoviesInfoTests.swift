//
//  MoviesInfoTests.swift
//  MoviesInfoTests
//
//  Created by Tobias Ruano on 07/01/2022.
//  Copyright © 2022 Tobias Ruano. All rights reserved.
//

import XCTest
@testable import MoviesInfo

class MoviesInfoTests: XCTestCase {
    
    var mockMovie: Movie!
    var viewModel: HomeViewModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func setUp() {
        mockMovie = Movie(title: "Test Title",
                      overview: "This is the overview of the test title movie",
                      releaseDate: "01/01/2000",
                      genreIds: [12, 16],
                      id: 1,
                      posterPath: "/posterpath",
                      backdropPath: "/backdropPath",
                          voteAverage: 7.5,
                      runtime: 127)
        viewModel = HomeViewModel(networkManager: NetworkMock.shared)
        viewModel.getWatchlist()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestMovies() {
        let expect = expectation(description: "server expectation")
        expect.expectedFulfillmentCount = 1
        
        let moviesToMatch: [Movie] = [Movie(title: "Test title",
                                            overview: "Some overview",
                                            releaseDate: "01/01/2022",
                                            genreIds: [1, 10, 11],
                                            id: 1,
                                            posterPath: "posterPath",
                                            backdropPath: "backdropPath",
                                            voteAverage: 7.8,
                                            runtime: 120)]
        
        viewModel.movieRequest(of: .nowPlaying)
        
        while viewModel.isLoadingMovies {}
        
        XCTAssertEqual(viewModel.movies, moviesToMatch)
        expect.fulfill()
        
        self.waitForExpectations(timeout: 10) { error in
            print(error?.localizedDescription as Any)
        }
    }
    
    func testGetWatchlist() {
        XCTAssertTrue(viewModel.watchlist != nil)
    }
    
    func testAddToWatchlist() {
        viewModel.movies.append(mockMovie)
        viewModel.addToWatchlist(movieIndexPath: 0)
        
        let userDefaults = UserDefaults.standard
        let savedMovies: [Movie]
        
        if let data = userDefaults.value(forKey: "watchlist") as? Data {
            let copy = try? PropertyListDecoder().decode([Movie].self, from: data)
            
            savedMovies = copy!
            XCTAssertTrue(savedMovies.contains(mockMovie))
        } else {
            XCTFail("The movie was not saved!!")
        }
    }
    
    func testRemoveFromWatchlist() {
        viewModel.movies.append(mockMovie)
        viewModel.removeFromWatchlist(indexPath: 0)
        
        let userDefaults = UserDefaults.standard
        let savedMovies: [Movie]
        if let data = userDefaults.value(forKey: "watchlist") as? Data {
            let copy = try? PropertyListDecoder().decode([Movie].self, from: data)
            savedMovies = copy!
            XCTAssertFalse(savedMovies.contains(mockMovie))
        } else {
            XCTFail()
        }
    }

}
