export class SpotModel {
  id: number;
  image: Resource | string;
  title: string;
  location: string;
  //详情页
  detailUrl: string;
  constructor(id: number, image: Resource | string, title: string, location: string,detailUrl:string) {
    this.id = id;
    this.image = image;
    this.title = title;
    this.location = location;
    this.detailUrl = detailUrl;
  }
}