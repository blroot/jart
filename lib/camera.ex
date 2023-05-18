defmodule Camera do
  alias Primitives.Ray
  eye = Graphmath.Vec3.create(0.0, 0.0, 1.0)
  center = Graphmath.Vec3.create()
  a = Graphmath.Vec3.subtract(eye, center)
  up = Graphmath.Vec3.create(0.0, 1.0, 0.0)
  b = up
  w = Graphmath.Vec3.normalize(a)
  u = Graphmath.Vec3.normalize(Graphmath.Vec3.cross(b, w))
  v = Graphmath.Vec3.cross(w, u)
  fov = (:math.pi())/180 * 45
  defstruct eye: eye, center: center, up: up, fov: fov, w: w, u: u, v: v

  def from(eye, center, up, fov) do
    a = Graphmath.Vec3.subtract(eye, center)
    b = up
    w = Graphmath.Vec3.normalize(a)
    u = Graphmath.Vec3.normalize(Graphmath.Vec3.cross(b, w))
    v = Graphmath.Vec3.cross(w, u)
    fov = (:math.pi())/180 * fov

    %Camera{eye: eye, center: center, up: up, fov: fov, w: w, u: u, v: v}
  end

  def ray_thru_pixel(camera, pixel_y, pixel_x, width, height) do
    pixel_x_center = pixel_x + 0.5
    pixel_y_center = pixel_y + 0.5

    aspect = width/height
    alpha = aspect * :math.tan(camera.fov/2.0) * (pixel_x_center - (width/2.0))/(width/2.0)
    beta = :math.tan(camera.fov/2.0) * ((height/2.0) - pixel_y_center)/(height/2.0)
    direction = Graphmath.Vec3.subtract(Graphmath.Vec3.add(Graphmath.Vec3.scale(camera.u, alpha), Graphmath.Vec3.scale(camera.v, beta)), camera.w)

    Ray.from(camera.eye, Graphmath.Vec3.normalize(direction))
  end
end
