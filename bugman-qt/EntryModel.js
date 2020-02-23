//import QtQuick 2.0

var data = [
    {
        name: "Set One",
        voucherFormat: "S001E%d",
        collector: "B. Parslow",
        entries: [
            {
                voucher: "S001A001",
                collector: "B. Parslow",
                position: {latitude: 1, longtitude: 2},
                timestamp: "1580432334818",
                images: ["/icons/cross.svg", "/icons/tick.svg"],
                fields: [
                    {
                        name: "Specimen Type",
                        type: "string",
                        value: "Bee",
                    },
                    {
                        name: "Specimen Count (int)",
                        type: "integer",
                        value: "2",
                    },
                    {
                        name: "State/Territory (list)",
                        type: "list",
                        value: "SA",
                        options: ["SA", "VIC", "TAS", "QLD", "WA", "NSW", "NT", "ACT"]
                    },
                    {
                        name: "Decimal",
                        type: "decimal",
                        value: ""
                    },
                     {
                        name: "Option 1",
                        type: "switch",
                        value: "Sweep"
                    },
                     {
                        name: "Option 2",
                        type: "switch",
                        value: "Daisy"
                    },
                    {
                        name: "Notes",
                        type: "text",
                    },
                ],
            },
            {
                voucher: "S001A002",
                collector: "B. Parslow",
                position: {latitude: 1, longtitude: 2},
                timestamp: "1580432134818",
            },
            {
                voucher: "S001A003",
                collector: "B. Parslow",
                position: {latitude: 1, longtitude: 2},
                timestamp: "1580432034818",
            },
        ],
    },
    {
        name: "Set Two",
        voucherFormat: "S002E%d",
        collector: "N. Thornberry",
        
        entries: [
            {
                voucher: "S002A001",
                collector: "N. Thornberry",
                position: {latitude: 1, longtitude: 2},
                timestamp: "1580432334818",
            },
            {
                voucher: "S002A002",
                collector: "N. Thornberry",
                position: {latitude: 1, longtitude: 2},
                timestamp: "1580432134818",
            },
            {
                voucher: "S002A003",
                collector: "N. Thornberry",
                position: {latitude: 1, longtitude: 2},
                timestamp: "1580432034818",
            },
        ],
    },
];
