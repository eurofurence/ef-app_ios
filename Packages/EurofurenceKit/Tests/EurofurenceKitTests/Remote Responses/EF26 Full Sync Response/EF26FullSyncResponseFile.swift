struct EF26FullSyncResponseFile: SampleResponseFile {
    
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
    
}
