// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

struct Weather {
    int256 latitude; // Latitude in microdegrees
    int256 longitude; // Longitude in microdegrees
    int256 temperature; // Temperature in microkelvins
    int256 windSpeed; // Wind speed in micro-meters per second
    uint256 windDeg; // Wind direction in degrees
    uint256 timestamp; // Timestamp in seconds since epoch
    string[] description; // Weather descriptions
}