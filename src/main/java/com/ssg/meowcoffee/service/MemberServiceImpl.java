package com.ssg.meowcoffee.service;

import com.ssg.meowcoffee.domain.CompanyVO;
import com.ssg.meowcoffee.domain.DeliverymanVO;
import com.ssg.meowcoffee.domain.ManagerVO;
import com.ssg.meowcoffee.domain.UserVO;
import com.ssg.meowcoffee.dto.CompanyDetailDTO;
import com.ssg.meowcoffee.dto.DeliverymanDTO;
import com.ssg.meowcoffee.dto.ManagerDetailDTO;
import com.ssg.meowcoffee.dto.UserCriteria;
import com.ssg.meowcoffee.dto.UserDetailDTO;
import com.ssg.meowcoffee.dto.UserInfoUpdateDTO;
import com.ssg.meowcoffee.dto.UserPageDTO;
import com.ssg.meowcoffee.dto.UserStatUpdateDTO;
import com.ssg.meowcoffee.mapper.MemberMapper;
import java.util.List;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

@Log4j2
@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService {

    private final MemberMapper memberMapper;
    private final ModelMapper modelMapper;

    @Override
    public UserPageDTO<UserDetailDTO> getUserList(UserCriteria userCriteria) {
        List<UserVO> userList = memberMapper.selectUsers(userCriteria);
        List<UserDetailDTO> userDetails = userList.stream()
                .map(userVO -> modelMapper.map(userVO, UserDetailDTO.class))
                .collect(Collectors.toList());
        int total = memberMapper.getCount(userCriteria);

        return UserPageDTO.<UserDetailDTO>builder()
                .cri(userCriteria)
                .dtoList(userDetails)
                .total(total)
                .build();
    }

    // 회원 리스트 조회 시, 승인대기/휴면상태/휴면대기인 회원의 정보를 관리자가 확인할 때 필요
    @Override
    public UserDetailDTO getUserById(String userId) {
        UserVO userVO = memberMapper.selectUserById(userId);
        UserDetailDTO userDetail = modelMapper.map(userVO, UserDetailDTO.class);
        return userDetail;
    }

    @Override
    public ManagerDetailDTO getManagerById(String userId) {
        ManagerVO managerVO = memberMapper.selectManagerById(userId);
        ManagerDetailDTO managerDetail = modelMapper.map(managerVO, ManagerDetailDTO.class);
        return managerDetail;
    }

    @Override
    public CompanyDetailDTO getCompanyById(String userId) {
        CompanyVO companyVO = memberMapper.selectCompanyById(userId);
        CompanyDetailDTO companyDetail = modelMapper.map(companyVO, CompanyDetailDTO.class);
        return companyDetail;
    }

    @Override
    public DeliverymanDTO getDeliverymenById(String userId) {
        DeliverymanVO deliverymanVO = memberMapper.selectDeliverymenById(userId);
        DeliverymanDTO deliverymanDTO = modelMapper.map(deliverymanVO, DeliverymanDTO.class);
        return deliverymanDTO;
    }

    @Override
    public void modifyUser(UserInfoUpdateDTO userInfoUpdateDTO) {
        memberMapper.updateUser(userInfoUpdateDTO);
    }

    @Override
    public void modifyUserStatus(UserStatUpdateDTO userStatUpdateDTO) {
        memberMapper.updateUserStatus(userStatUpdateDTO);
    }

    @Override
    public void deactivateUser(String currentId) {
        memberMapper.deleteUser(currentId);
    }

    @Override
    public void deactivateUserByAdmin(String targetId) {
        memberMapper.deleteUserByAdmin(targetId);
    }
}
