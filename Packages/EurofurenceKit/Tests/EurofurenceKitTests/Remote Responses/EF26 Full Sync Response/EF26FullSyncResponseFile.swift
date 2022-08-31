struct EF26FullSyncResponseFile: SyncResponseFile {
    
    var jsonFileName: String {
        return "EF26_Full_Sync_Response"
    }
    
    var days: [ExpectedDay] {
        return [
            .init(
                lastUpdated: "2022-06-23T08:18:09.424Z",
                identifier: "db6e0b07-3300-4d58-adfd-84c145e36242",
                name: "Early Arrival",
                date: "2022-08-23T00:00:00.000Z"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.429Z",
                identifier: "572ca56c-c473-4ca7-b4ec-c6498c077dda",
                name: "Official Con Start/Con Day 1",
                date: "2022-08-24T00:00:00.000Z"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.431Z",
                identifier: "7f69f120-3c8a-49bf-895a-20c2adade161",
                name: "Con Day 2",
                date: "2022-08-25T00:00:00.000Z"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.432Z",
                identifier: "bea15e67-4775-49fc-84e4-6c20a30a1943",
                name: "Con Day 3",
                date: "2022-08-26T00:00:00.000Z"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.433Z",
                identifier: "b15cef00-d4b9-4c2a-8e31-7bcb75e21fc7",
                name: "Con Day 4",
                date: "2022-08-27T00:00:00.000Z"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.435Z",
                identifier: "88fc8d21-f80e-4b73-8a85-e9a263a801d6",
                name: "Last Day/Con Day 5",
                date: "2022-08-28T00:00:00.000Z"
            )
        ]
    }
    
    var tracks: [ExpectedTrack] {
        return [
            .init(
                lastUpdated: "2022-06-23T08:18:09.205Z",
                identifier: "f23cc7f6-34c1-48d5-8acb-0ec10c353403",
                name: "Art Show"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.344Z",
                identifier: "38ef060d-06e1-46dd-8b15-989c35158f86",
                name: "Charity"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.346Z",
                identifier: "cb63dd74-6143-45f1-917c-8648082f96fe",
                name: "Creating Art"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.347Z",
                identifier: "675c3a7c-ad93-441c-8b66-d15f3f3609e4",
                name: "Dealers' Den"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.349Z",
                identifier: "f0ada704-c876-42a1-8da4-59cbcf7ab413",
                name: "Fursuit"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.350Z",
                identifier: "9c0c41ab-c937-4299-a0a4-20daa6d77458",
                name: "Games | Social"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.352Z",
                identifier: "7d50ac56-9485-4211-a0b0-146a5f5a8fe3",
                name: "Guest of Honor"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.353Z",
                identifier: "98aba1f3-da78-4b06-8916-979d8719cf3b",
                name: "Lobby and Outdoor"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.356Z",
                identifier: "0b80cc7b-b5b2-4fab-8b74-078f2b5e366e",
                name: "Misc."
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.358Z",
                identifier: "de678a6d-4a07-47c3-84c7-ea7aa70f3f55",
                name: "Music"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.359Z",
                identifier: "621e6ab9-cc7f-41fc-810a-4f78dfa59c74",
                name: "Performance"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.361Z",
                identifier: "1af389c5-7e1c-4524-8db2-ce7551b3c4eb",
                name: "Stage"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.363Z",
                identifier: "4acb394d-c8e3-4f65-8a17-b67c77f33cc2",
                name: "Supersponsor Event"
            ),
            .init(
                lastUpdated: "2022-06-23T08:18:09.365Z",
                identifier: "c1cec323-1562-4958-97c0-36448d18b1cb",
                name: "Writing"
            ),
            .init(
                lastUpdated: "2022-07-16T23:00:05.510Z",
                identifier: "c038266c-3f9c-4806-ba9d-6f7bb2027edd",
                name: "Animation"
            ),
            .init(
                lastUpdated: "2022-08-03T10:30:05.169Z",
                identifier: "dac39c38-da16-4b18-9e90-d17b785ee5a8",
                name: "Dance"
            ),
            .init(
                lastUpdated: "2022-08-15T23:30:04.817Z",
                identifier: "e0b66f0e-f51a-4e76-8b52-0602d7412bc3",
                name: "Maker ∕ Theme-based Fursuit Group Photo"
            )
        ]
    }
    
    var rooms: [ExpectedRoom] {
        return [
            .init(
                lastUpdated: "2022-07-30T11:14:50.775Z",
                identifier: "2d5d9a98-aaca-4434-959d-99d20e675d3a",
                name: "Art Show — Convention Hall Section D",
                shortName: "Art Show"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.777Z",
                identifier: "4fdf6f0b-adf0-49b8-801f-70b026733538",
                name: "Artist Lounge — Foyer Estrel Hall",
                shortName: "Artist Lounge"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.779Z",
                identifier: "51bb19cb-a658-4cd5-b7cf-b655355040bf",
                name: "Club Stage — Estrel Hall A",
                shortName: "Club Stage"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.782Z",
                identifier: "f48c3415-907d-4ebe-9483-3033e2539563",
                name: "ConOps | Frontoffice — Estrel Hall B",
                shortName: "ConOps | Frontoffice"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.784Z",
                identifier: "3465b19a-fe53-45fd-b3ee-e6df1be71e15",
                name: "Dealers' Den — Convention Hall Section C",
                shortName: "Dealers' Den"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.789Z",
                identifier: "61c6d51a-a0f4-46ba-a719-d09d859afa26",
                name: "ECC Room 1",
                shortName: "ECC Room 1"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.790Z",
                identifier: "52b9576a-48b5-47ec-b295-de6fc895bb71",
                name: "ECC Room 4",
                shortName: "ECC Room 4"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.792Z",
                identifier: "9ebc2135-aa51-4042-ba92-670bd118c6f3",
                name: "ECC Room 5",
                shortName: "ECC Room 5"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.793Z",
                identifier: "7fe3490e-bab8-4651-bea5-83d5b545919c",
                name: "Entrance Rotunda",
                shortName: "Entrance Rotunda"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.795Z",
                identifier: "193d8ce2-6d9a-43f0-93de-05c35e3e010f",
                name: "Estrel Beergarden",
                shortName: "Estrel Beergarden"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.797Z",
                identifier: "e2ff4cbf-1ed8-494b-b6a0-67f19d503769",
                name: "Fursuit Lounge — ECC Room 3",
                shortName: "Fursuit Lounge"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.799Z",
                identifier: "d485995d-4550-40b7-a729-1a19f5a373a6",
                name: "Fursuit Photoshoot Registration — Estrel Hall B",
                shortName: "Fursuit Photoshoot Registration"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.800Z",
                identifier: "face6d3a-6db0-463a-9cf4-432cdd7d6757",
                name: "Lyon",
                shortName: "Lyon"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.802Z",
                identifier: "979f4ecf-66bd-4c83-ac3c-c3636ff82a81",
                name: "Main Stage — Convention Hall Section A",
                shortName: "Main Stage"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.805Z",
                identifier: "1a181eac-fd0d-4144-8339-c4000904d84d",
                name: "Office Passage",
                shortName: "Office Passage"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.807Z",
                identifier: "9c28630f-a667-40da-960c-c12500c653a1",
                name: "Open Stage — ECC Foyer 1",
                shortName: "Open Stage"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.808Z",
                identifier: "62060c43-76a8-49de-8389-511790f52917",
                name: "Paris",
                shortName: "Paris"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.810Z",
                identifier: "b321418c-cf44-47a7-a7e9-3281bd6a7bd2",
                name: "Photoshooting — Convention Hall Section D",
                shortName: "Photoshooting"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.813Z",
                identifier: "496fa438-9917-46b0-8f44-0fbeb05b3821",
                name: "Registration — Estrel Hall C",
                shortName: "Registration"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.814Z",
                identifier: "c137717f-f297-4c3d-bc0e-542cbb032135",
                name: "Registration, Con Shop — Paris",
                shortName: "Registration, Con Shop"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.816Z",
                identifier: "d6efe16f-9fd2-4f21-8e5e-b5cc5cc46c66",
                name: "Straßburg",
                shortName: "Straßburg"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.658Z",
                identifier: "4d64ba76-8a9b-4dd1-9b78-c159e38c5292",
                name: "AD Dealers' Den — Convention Hall Section C Level 1",
                shortName: "AD Dealers' Den"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.803Z",
                identifier: "8e9a2236-c83b-4206-aff8-fe73880e796a",
                name: "Nizza",
                shortName: "Nizza"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.786Z",
                identifier: "4b63218d-e78d-4127-9b75-bcbb585b8703",
                name: "ECC Foyer 2 — VR Portal",
                shortName: "ECC Foyer 2"
            ),
            .init(
                lastUpdated: "2022-07-30T11:14:50.787Z",
                identifier: "6366daef-34fc-47b1-98a6-3b6f4f24bde2",
                name: "ECC Foyer 3 — Artist Alley",
                shortName: "ECC Foyer 3"
            ),
            .init(
                lastUpdated: "2022-08-16T00:00:06.296Z",
                identifier: "5db1fdc8-980f-4e0f-b6f5-665468d3fa11",
                name: "Rotunda",
                shortName: "Rotunda"
            ),
            .init(
                lastUpdated: "2022-08-16T19:30:04.667Z",
                identifier: "95e0ee88-8447-4c29-8362-c4dd06f6d39c",
                name: "Main Stage",
                shortName: "Main Stage"
            ),
            .init(
                lastUpdated: "2022-08-17T22:30:05.656Z",
                identifier: "7588ab3d-39a1-4635-80a7-bdbcff50c7c3",
                name: "Small Lobby ­— Passage Estrel Hall",
                shortName: "Small Lobby ­"
            ),
            .init(
                lastUpdated: "2022-08-23T20:00:05.729Z",
                identifier: "683c3c60-e0fb-47e3-a39c-ef75a0777c54",
                name: "Entrance Fursuit Lounge — Entrance ECC Room 3",
                shortName: "Entrance Fursuit Lounge"
            ),
            .init(
                lastUpdated: "2022-08-23T23:00:05.388Z",
                identifier: "75bb1d1b-5f42-4156-9e62-9104132ceb90",
                name: "Below Rotunda — Food Trucks",
                shortName: "Below Rotunda"
            ),
            .init(
                lastUpdated: "2022-08-24T12:30:05.279Z",
                identifier: "d8e26090-6093-459c-95c8-63f0348f41c6",
                name: "Lobby — Atrium",
                shortName: "Lobby"
            ),
            .init(
                lastUpdated: "2022-08-25T23:30:05.563Z",
                identifier: "aa998c8b-d0d7-4812-b2ab-29c83228f35d",
                name: "Outdoor",
                shortName: "Outdoor"
            ),
            .init(
                lastUpdated: "2022-08-26T00:00:06.394Z",
                identifier: "43c996b7-cbcb-497c-87fd-6aee63136947",
                name: "Outdoor — Campfire",
                shortName: "Outdoor"
            ),
            .init(
                lastUpdated: "2022-08-27T01:30:05.069Z",
                identifier: "7169741d-dc82-457a-bb5e-4bcf15e34278",
                name: "Rotunda ",
                shortName: "Rotunda "
            )
        ]
    }
    
    var events: [ExpectedEvent] {
        return [
            .init(
                lastUpdated: "2022-08-22T19:30:05.600Z",
                identifier: "76430fe0-ece7-48c9-b8e6-fdbc3974ff64",
                slug: "reg_tue",
                title: "Registration",
                subtitle: "",
                abstract: "Take me to the Reg Line!",
                dayIdentifier: "db6e0b07-3300-4d58-adfd-84c145e36242",
                trackIdentifier: "0b80cc7b-b5b2-4fab-8b74-078f2b5e366e",
                roomIdentifier: "c137717f-f297-4c3d-bc0e-542cbb032135",
                description: "Take me to the Reg Line!\r\n\r\nIn case you arrive after Registration closes, go to the Security Office in Estrel Saal C to get your Badge.",
                startDate: "2022-08-23T10:00:00.000Z",
                endDate: "2022-08-23T18:00:00.000Z",
                panelHosts: ["EF Staff"],
                deviatingFromConbook: false,
                acceptingFeedback: false,
                tags: ["mask_required"],
                bannerImageIdentifier: nil,
                posterImageIdentifier: nil
            ),
            
            .init(
                lastUpdated: "2022-08-21T16:18:04.893Z",
                identifier: "4a90c95f-dac0-4ca0-9f6d-a7839845ba36",
                slug: "ms_fursuit_friendly_dance",
                title: "The Pirate's Paradise",
                subtitle: "",
                abstract: "This is Eurofurence's Club Night. We don't hold back. Neither should you. It's time to party.",
                dayIdentifier: "7f69f120-3c8a-49bf-895a-20c2adade161",
                trackIdentifier: "dac39c38-da16-4b18-9e90-d17b785ee5a8",
                roomIdentifier: "979f4ecf-66bd-4c83-ac3c-c3636ff82a81",
                description: "The Pirate's Paradise brings you what every sea dog needs. Loud thumping beats from the bass cannon and shining bright lights in the sky. \r\n\r\nThe Eurofurence Club Night not only pulled all strings to get the chairman himself behind the decks, it's also gonna blow your mind with a wide selection of music and a stage unlike anything you've ever seen. Ready for a ride? Welcome to the Paradise!",
                startDate: "2022-08-25T19:30:00.000Z",
                endDate: "2022-08-26T01:30:00.000Z",
                panelHosts: ["Eurofurence DJs", "Jaryic"],
                deviatingFromConbook: false,
                acceptingFeedback: false,
                tags: ["stage", "main_stage"],
                bannerImageIdentifier: "b58304dc-4b1c-4857-9ba6-818c593b2f6e",
                posterImageIdentifier: "16462c95-4aeb-4557-986c-9d3193a67607"
            )
        ]
    }
    
    var images: [ExpectedImage] {
        return [
            .init(
                lastUpdated: "2022-08-21T16:18:04.792Z",
                identifier: "b58304dc-4b1c-4857-9ba6-818c593b2f6e",
                internalReference: "event:Banner:4a90c95f-dac0-4ca0-9f6d-a7839845ba36",
                width: 1280,
                height: 427,
                sizeInBytes: 461521,
                mimeType: "image/png",
                contentHashSha1: "JdsAVGreKRoL6M3TGNNpcNCsajI="
            ),
            
            .init(
                lastUpdated: "2022-08-16T08:30:21.253Z",
                identifier: "16462c95-4aeb-4557-986c-9d3193a67607",
                internalReference: "event:Poster:0d7817c3-03c4-48a7-bcf9-5cd690e86368",
                width: 2339,
                height: 3308,
                sizeInBytes: 1133398,
                mimeType: "image/jpeg",
                contentHashSha1: "aoU0oeC4LqJ9KoxYevHeryHbl/8="
            )
        ]
    }
    
}
