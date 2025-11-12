package com.ssg.meowcoffee.dto;

import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class VehicleDTO {
    private String vehicleId;
    private String vehicleModel;
    private String vehicleDesc;
}
