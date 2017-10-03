module Select.SearchTest exposing (..)

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
    , "Star Wars: Episode III - Revenge of the Sith (2005)"
    , "Transformers: Revenge of the Fallen (2009)"
    , "The Twilight Saga: Breaking Dawn, Part 2 (2012)"
    , "Inception (2010)"
    , "Spider-Man (2002)"
    , "Independence Day (1996)"
    , "Shrek the Third (2007)"
    , "Harry Potter and the Prisoner of Azkaban (2004)"
    , " E. T. The Extra-Terrestrial (1982)"
    , "Fast & Furious 6 (2013)"
    , "Indiana Jones and the Kingdom of the Crystal Skull (2008)"
    , "Spider-Man 2 (2004)"
    , " Star Wars: Episode IV - A New Hope (1977)"
    , "Deadpool (2016)"
    , "Guardians of the Galaxy (2014)"
    , "2012 (2009)"
    , "Maleficent (2014)"
    , "The Da Vinci Code (2006)"
    , "The Amazing Spider-Man (2012)"
    , "The Hunger Games: Mockingjay - Part 1 (2014)"
    , "Shrek Forever After (2010)"
    , "X-Men: Days of Future Past (2014)"
    , "Madagascar 3: Europe's Most Wanted (2012)"
    , "The Chronicles of Narnia: The Lion, the Witch and the Wardrobe (2005)"
    , "Monsters University (2013)"
    , "Suicide Squad (2016)"
    , "The Matrix Reloaded (2003)"
    , "Up (2009)"
    , "Gravity (2013)"
    , "Captain America: The Winter Soldier (2014)"
    , "The Twilight Saga: Breaking Dawn, Part 1 (2011)"
    , "Dawn of the Planet of the Apes (2014)"
    , "The Twilight Saga: New Moon (2009)"
    , "Transformers (2007)"
    , "The Amazing Spider-Man 2 (2014)"
    , "The Twilight Saga: Eclipse (2010)"
    , "Mission: Impossible - Ghost Protocol (2011)"
    , "The Hunger Games (2012)"
    , "Mission: Impossible - Rogue Nation (2015)"
    , "Forrest Gump (1994)"
    , "Interstellar (2014)"
    , "The Sixth Sense (1999)"
    , "Man of Steel (2013)"
    , "Kung Fu Panda 2 (2011)"
    , "Ice Age: The Meltdown (2006)"
    , "Big Hero 6 (2014)"
    , "Pirates of the Caribbean: The Curse of the Black Pearl (2003)"
    , "The Hunger Games: Mockingjay - Part 2 (2015)"
    , "Star Wars: Episode II - Attack of the Clones (2002)"
    ]


baseConfig : Config Msg String
baseConfig =
    newConfig OnSelect identity


testScoreForItem =
    let
        movie1 =
            "Star Wars: Episode VII - The Force Awakens"

        inputs =
            [ ( "Scores the beginning"
              , baseConfig
              , movie1
              , "star"
              , 380
              )
            , ( "Scores at the end"
              , baseConfig
              , movie1
              , "force"
              , 2395
              )
            ]

        run ( testCase, config, movie, query, expectedScore ) =
            let
                actualScore =
                    scoreForItem config query movie

                expectation =
                    Expect.equal actualScore expectedScore
            in
                test testCase (\_ -> expectation)
    in
        describe "scoreForItem" (List.map run inputs)


testMatchedItems =
    let
        inputs =
            [ ( "Query can be at the beginning"
              , baseConfig
              , Just "star"
              )
            ]

        run ( testCase, config, query ) =
            let
                actual =
                    matchedItems config query movies

                expected =
                    ItemsFound [ " Star Wars: Episode IV - A New Hope (1977)", "Star Wars: Episode I - The Phantom Menace (1999)", "Star Wars: Episode VII - The Force Awakens (2015)", "Star Wars: Episode III - Revenge of the Sith (2005)", "Star Wars: Episode II - Attack of the Clones (2002)" ]

                expectation =
                    Expect.equal actual expected
            in
                test testCase (\_ -> expectation)
    in
        describe "matchedItems" (List.map run inputs)


all =
    describe "SearchTest"
        [ testScoreForItem
        , testMatchedItems
        ]
