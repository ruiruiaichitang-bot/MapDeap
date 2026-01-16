export class SpotModel {
  id: number;
  image: Resource;
  title: string;
  location: string;
  constructor(id: number, image: Resource, title: string, location: string) {
    this.id = id;
    this.image = image;
    this.title = title;
    this.location = location;
  }
}