defmodule WaterCooler.ChatRoom do

  def publish(message) do
    :gproc.send({:p, :l, :chat}, {:message, message})
  end

  def join() do
    :gproc.reg({:p, :l, :chat})
  end
end
