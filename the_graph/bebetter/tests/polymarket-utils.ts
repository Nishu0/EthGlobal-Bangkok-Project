import { newMockEvent } from "matchstick-as"
import { ethereum, BigInt, Address } from "@graphprotocol/graph-ts"
import { QuestionCreated } from "../generated/Polymarket/Polymarket"

export function createQuestionCreatedEvent(
  id: BigInt,
  question: string,
  timestamp: BigInt,
  createdBy: Address,
  creatorImageHash: string,
  totalAmount: BigInt,
  totalYesAmount: BigInt,
  totalNoAmount: BigInt
): QuestionCreated {
  let questionCreatedEvent = changetype<QuestionCreated>(newMockEvent())

  questionCreatedEvent.parameters = new Array()

  questionCreatedEvent.parameters.push(
    new ethereum.EventParam("id", ethereum.Value.fromUnsignedBigInt(id))
  )
  questionCreatedEvent.parameters.push(
    new ethereum.EventParam("question", ethereum.Value.fromString(question))
  )
  questionCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "timestamp",
      ethereum.Value.fromUnsignedBigInt(timestamp)
    )
  )
  questionCreatedEvent.parameters.push(
    new ethereum.EventParam("createdBy", ethereum.Value.fromAddress(createdBy))
  )
  questionCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "creatorImageHash",
      ethereum.Value.fromString(creatorImageHash)
    )
  )
  questionCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "totalAmount",
      ethereum.Value.fromUnsignedBigInt(totalAmount)
    )
  )
  questionCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "totalYesAmount",
      ethereum.Value.fromUnsignedBigInt(totalYesAmount)
    )
  )
  questionCreatedEvent.parameters.push(
    new ethereum.EventParam(
      "totalNoAmount",
      ethereum.Value.fromUnsignedBigInt(totalNoAmount)
    )
  )

  return questionCreatedEvent
}
