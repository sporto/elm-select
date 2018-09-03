module Select.SearchTest exposing (all)

import Expect exposing (Expectation)
import Select.Config exposing (Config, newConfig)
import Select.Search exposing (..)
import Test exposing (..)


type Msg
    = OnSelect (Maybe String)


movies : List String
movies =
    [ "Avatar (2009)"
    , "Titanic (1997)"
    , "Star Wars: Episode VII - The Force Awakens (2015)"
    , "Jurassic World (2015)"
    , "Marvel's The Avengers (2012)"
    , "Furious 7 (2015)"
    , "Avengers: Age of Ultron (2015)"
    , "Harry Potter and the Deathly Hallows, Part 2 (2011)"
    , "Frozen (2013)"
    , "Iron Man 3 (2013)"
    , "Minions (2015)"
    , "Captain America: Civil War (2016)"
    , "Transformers: Dark of the Moon (2011)"
    , "The Lord of the Rings: The Return of the King (2003)"
    , "Skyfall (2012)"
    , "Transformers: Age of Extinction (2014)"
    , "The Dark Knight Rises (2012)"
    , "Pirates of the Caribbean: Dead Man's Chest (2006)"
    , "Toy Story 3 (2010)"
    , "Pirates of the Caribbean: On Stranger Tides (2011)"
    , "Jurassic Park (1993)"
    , "Star Wars: Episode I - The Phantom Menace (1999)"
    , "Finding Dory (2016)"
    , "Alice in Wonderland (2010)"
    , "Zootopia (2016)"
    , "The Hobbit: An Unexpected Journey (2012)"
    , "The Dark Knight (2008)"
    , "Harry Potter and the Sorcerer's Stone (2001)"
    , "Despicable Me 2 (2013)"
    , "The Lion King (1994)"
    , "The Jungle Book (2016)"
    , "Pirates of the Caribbean: At World's End (2007)"
    , "Harry Potter and the Deathly Hallows, Part 1 (2010)"
    , "The Hobbit: The Desolation of Smaug (2013)"
    , "The Hobbit: The Battle of the Five Armies (2014)"
    , "Harry Potter and the Order of the Phoenix (2007)"
    , "Finding Nemo (2003)"
    , "Harry Potter and the Half-Blood Prince (2009)"
    , "The Lord of the Rings: The Two Towers (2002)"
    , "Shrek 2 (2004)"
    , "Harry Potter and the Goblet of Fire (2005)"
    , "Spider-Man 3 (2007)"
    , "Ice Age: Dawn of the Dinosaurs (2009)"
    , "Spectre (2015)"
    , "Harry Potter and the Chamber of Secrets (2002)"
    , "Ice Age: Continental Drift (2012)"
    , "The Secret Life of Pets (2016)"
    , "Batman v Superman: Dawn of Justice (2016)"
    , "The Lord of the Rings: The Fellowship of the Ring (2001)"
    , "The Hunger Games: Catching Fire (2013)"
    , "Inside Out (2015)"
    ]


baseConfig : Config Msg String
baseConfig =
    newConfig OnSelect identity


scoreForItemTest testCase config movie query expectedScore =
    let
        actualScore =
            scoreForItem config query movie

        expectation =
            Expect.equal actualScore expectedScore
    in
    test testCase (\_ -> expectation)


scoreForItemTests =
    let
        movie1 =
            "Star Wars: Episode VII - The Force Awakens"
    in
    describe "scoreForItem"
        [ scoreForItemTest
            "Scores the beginning"
            baseConfig
            movie1
            "star"
            0
        , scoreForItemTest
            "Scores at the end"
            baseConfig
            movie1
            "force"
            0
        ]


relevantScoreForItemTest testCase config movie1 movie2 query expectedOrder =
    let
        score1 =
            scoreForItem config query movie1

        score2 =
            scoreForItem config query movie2

        actual =
            compare score1 score2

        expectation =
            Expect.equal actual expectedOrder
    in
    test testCase (\_ -> expectation)


relevantScoreForItemTests =
    describe "scoreForItem comparison"
        [ relevantScoreForItemTest
            "Relevant scores better (lower)"
            baseConfig
            "Star Wars: Episode VII - The Force Awakens"
            "The Hunger Games: Catching Fire (2013)"
            "star"
            LT
        ]


matchedItemsTest testCase config query expected =
    let
        actual =
            matchedItems config query movies

        expectation =
            Expect.equal actual expected
    in
    test testCase (\_ -> expectation)


matchedItemsTests =
    describe "matchedItems"
        [ matchedItemsTest
            "Query can be at the beginning"
            baseConfig
            (Just "star")
            (ItemsFound
                [ "Star Wars: Episode VII - The Force Awakens (2015)"
                , "Star Wars: Episode I - The Phantom Menace (1999)"
                , "Pirates of the Caribbean: On Stranger Tides (2011)"
                ]
            )
        , matchedItemsTest
            "Query can be at the end"
            baseConfig
            (Just "menace")
            (ItemsFound
                [ "Star Wars: Episode I - The Phantom Menace (1999)"
                ]
            )
        ]


all =
    describe "SearchTest"
        [ scoreForItemTests
        , relevantScoreForItemTests
        , matchedItemsTests
        ]
