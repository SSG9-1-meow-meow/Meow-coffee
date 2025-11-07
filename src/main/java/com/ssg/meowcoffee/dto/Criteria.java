package com.ssg.meowcoffee.dto;

import lombok.Data;

@Data
public class Criteria {

  private int pageNum = 1;
  private int amount;

  //null, T, C, W, TC, TW, TCW
  private String[] types;
  private String keyword;

  private String typeStr;

  public void setTypes(String[] types){
    this.types = types;

    if(types != null && types.length > 0){
      typeStr = String.join("", types);
    }
  }


  public void setPageNum(int pageNum) {

    if(pageNum <= 0){
      this.pageNum = 1;
      return;
    }
    this.pageNum = pageNum;
  }

  public void setAmount(int amount) {

    if(amount <= 10 || amount > 30) {
      this.amount = 10;
      return;
    }
    this.amount = amount; //하고 싶은대로 amount 설정
  }

  public int getSkip(){

    return (this.pageNum - 1) * this.amount;

  }


}