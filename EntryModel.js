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
                date: 1580432334818,
                fields: [
                    {
                        name: "Specimen Type",
                        type: "string",
                        value: "Bee",
                    },
                    {
                        name: "Specimen Count",
                        type: "string",
                        value: "2",
                    },
                    {
                        name: "State/Territory",
                        type: "string",
                        value: "SA"
                    },
                    {
                        name: "Location",
                        type: "string",
                        value: "N of Snowtown"
                    },
                     {
                        name: "Method",
                        type: "string",
                        value: "Sweep"
                    },
                     {
                        name: "Flower/Host Plant",
                        type: "string",
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
                date: 1580432134818,
            },
            {
                voucher: "S001A003",
                collector: "B. Parslow",
                position: {latitude: 1, longtitude: 2},
                date: 1580432034818,
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
                date: 1580432334818,
            },
            {
                voucher: "S002A002",
                collector: "N. Thornberry",
                position: {latitude: 1, longtitude: 2},
                date: 1580432134818,
            },
            {
                voucher: "S002A003",
                collector: "N. Thornberry",
                position: {latitude: 1, longtitude: 2},
                date: 1580432034818,
            },
        ],
    },
];
